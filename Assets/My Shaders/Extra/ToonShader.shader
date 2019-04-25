Shader "Custom/ToonShader" 
{
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 1)
	}

	Subshader
	{
		CGPROGRAM

		#pragma surface surf Stepped fullforwardshadows
		#pragma target 3.0

		fixed4 _Color;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input i, inout SurfaceOutput o)
		{
			fixed4 col = _Color;
			o.Albedo = col.rgb;
		}

		float4 LightingStepped(SurfaceOutput s, float3 lightDir, half3 viewDir, float  shadowAttenuation)
		{
			float towardsLight = dot(s.Normal, lightDir);
			float lightIntensity = step(0, towardsLight);
			return lightIntensity;
		}

		ENDCG
	}
	
}
