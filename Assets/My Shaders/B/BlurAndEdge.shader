Shader "Custom/BlurAndEdge"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Blur ("Blur", Float) = 5 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;

			float _Blur;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				int blur = max((int)_Blur, 0);

				if (blur == 0) {
					return tex2D(_MainTex, i.uv);
				}

				float2 texel = float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y);

				float3 avg = 0.0;

				for (int x = -blur; x <= blur; x++) {
					for (int y = -blur; y <= blur; y++) {
						avg += tex2D(_MainTex, i.uv + texel * float2(x, y));
					}
				}

				avg /= (blur * 2 + 1) * (blur * 2 + 1);

				return float4(avg, 1.0);
            }
            ENDCG
        }

		Pass
		{
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;

			float _Blur;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 texel = float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y);

				float3x3 Gx = float3x3(-1, -2, -1, 0, 0, 0, 1, 2, 1); // x direction kernel
				float3x3 Gy = float3x3(-1, 0, 1, -2, 0, 2, -1, 0, 1); // y direction kernel


				// fetch the 3x3 neighborhood of a fragment
				float tx0y0 = tex2D(_MainTex, i.uv + texel * float2(-1, -1)).r;
				float tx0y1 = tex2D(_MainTex, i.uv + texel * float2(-1,  0)).r;
				float tx0y2 = tex2D(_MainTex, i.uv + texel * float2(-1,  1)).r;

				float tx1y0 = tex2D(_MainTex, i.uv + texel * float2(0, -1)).r;
				float tx1y1 = tex2D(_MainTex, i.uv + texel * float2(0,  0)).r;
				float tx1y2 = tex2D(_MainTex, i.uv + texel * float2(0,  1)).r;

				float tx2y0 = tex2D(_MainTex, i.uv + texel * float2(1, -1)).r;
				float tx2y1 = tex2D(_MainTex, i.uv + texel * float2(1,  0)).r;
				float tx2y2 = tex2D(_MainTex, i.uv + texel * float2(1,  1)).r;

				float valueGx = Gx[0][0] * tx0y0 + Gx[1][0] * tx1y0 + Gx[2][0] * tx2y0 +
						Gx[0][1] * tx0y1 + Gx[1][1] * tx1y1 + Gx[2][1] * tx2y1 +
						Gx[0][2] * tx0y2 + Gx[1][2] * tx1y2 + Gx[2][2] * tx2y2;

				float valueGy = Gy[0][0] * tx0y0 + Gy[1][0] * tx1y0 + Gy[2][0] * tx2y0 +
						Gy[0][1] * tx0y1 + Gy[1][1] * tx1y1 + Gy[2][1] * tx2y1 +
						Gy[0][2] * tx0y2 + Gy[1][2] * tx1y2 + Gy[2][2] * tx2y2;

				float G = sqrt((valueGx * valueGx) + (valueGy * valueGy));

				return float4(G, valueGx, valueGy, 1);
			}
			ENDCG
		}
    }
}
